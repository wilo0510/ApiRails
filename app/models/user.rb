class User < ApplicationRecord
    has_many :posts
    validates :email, presence: true
    validates :name, presence: true
    validates :auth_token,presence: true
    #Metodo que nos provee rails para ejecutar metodos despues de inicializado el objeto
    after_initialize :generate_auth_token

    def generate_auth_token 
        #se hace despues de cada User.new
        #if !auth_token.present?
        unless auth_token.present?
            #generate_token
            self.auth_token= TokenGenerationService.generate
        end
    end
end
