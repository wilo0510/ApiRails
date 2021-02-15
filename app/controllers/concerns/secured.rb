module Secured
    def authenticate_user!
        token_regex= /Bearer (\w+)/
        #Leer el header de auth y se debe verificar que sea valido 
        #Verificar que el token que extraemos corresponda a un usuario
        headers = request.headers
        if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
            token=headers['Authorization'].match(token_regex)[1]
            if(Current.user=User.find_by_auth_token(token))
                return 
            end
        end
        render json:{error: 'Unauthorized'},status: :unauthorized
    end
end
