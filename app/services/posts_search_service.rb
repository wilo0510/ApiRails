class PostsSearchService
    #Metodo de clase se define con self
    def self.search(curr_posts,query)
        curr_posts.where("title like '%#{query}%'")
    end
end
