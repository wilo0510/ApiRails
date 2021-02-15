class PostsController < ApplicationController
    include Secured
    #Garantizamos que antes de update y create el usuario esté autenticado
    #Por convencion se usa ! para indicar que modifica las peticiones 
    before_action :authenticate_user!, only: [:create, :update]
    #El orden es importante entre mas abajo se especifique el rescue_from 
    #tiene mas prioridad sobre los primeros
    rescue_from Exception do |e|
        render json: {error: e.message}, status: :internal_server_error
    end
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json:{error: e.message},status: :not_found
    end
    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end
    #GET /posts
    def index
       @posts=Post.where(published: true)
       if !params[:search].nil? && params[:search].present?
         @posts= PostsSearchService.search(@posts,params[:search])
       end
       #el includes hace que rails haga un solo query para extraer todos los usuarios
       #y lo hace en un solo query
       render json: @posts.includes(:user), status: :ok 
    end
    #GET /posts/{id}
    def show
        @post=Post.find(params[:id]) #Cuando no encuentra arroja la excepcion ActtiveRecord::RecordNotFound
        #Si el articulo esta publicado se muestra , sino solo se 
        #muestra el borrador del usuario
        if (@post.published? || (Current.user && @post.user_id==Current.user.id ) )
            render json: @post,status: :ok
        else
            render json: {error: 'Not found'}, status: :not_found
        end
    end
    #POST /posts
    def create
        @post= Current.user.posts.create!(create_params)
        render json: @post,status: :created
    end
    #POST /posts/{id}
    def update
        @post=Current.user.posts.find(params[:id])
        @post.update!(update_params)
        render json: @post, status: :ok 
    end
    private
    def create_params
        params.require(:post).permit(:title,:content,:published)
    end
    def update_params
        params.require(:post).permit(:title,:content,:published)
    end
    
end