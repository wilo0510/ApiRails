class PostSerializer < ActiveModel::Serializer
  attributes :id, :title,:content, :published,:author
  #Como author no esta definido dentro del modelo, se tiene que definir aparte 
  def author
    #Hace referencia al post que esta siendo serializado
    user=self.object.user 
    {
      name: user.name,
      email: user.email,
      id: user.id 
    }
  end
end
