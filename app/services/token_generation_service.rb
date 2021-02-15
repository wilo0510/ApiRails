class TokenGenerationService 
    def self.generate 
        #Metodo de rails random strings
       SecureRandom.hex
    end
end