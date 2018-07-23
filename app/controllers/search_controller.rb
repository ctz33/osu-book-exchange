class SearchController < ApplicationController

	def search

	  # books = Book.search{fulltext params[:query]}.results
	  # # @msg=[]
	  # # @posts = Post.search{fulltext params[:query] }.results
	  # @posts = []
	  # books.each do
	  #   |book|
	  #   Post.search{fulltext book.id do fields(:book_id) end}.results.each do
	  #     |post|
	  #     @posts.append(post)
	  #   end
	  # end
	  # # @msg = "This is message: "+params[:query]
	  # # @msg = "Book Title: "
	  # @page_title="My Search Posts"

	  books = book_search params[:query], params[:edition]
	  post_refine_search books.results

	end

	def book_search query, edition
		Book.search do
			# Match title or ISBN
			fulltext query do
				if params[:search_for]=='Title' then
					fields(:title)
				elsif params[:search_for]=='ISBN' then
					fields(:ISBN_10, :ISBN_13)
				end
			end

			# Match edition
			if edition!="all" then
				fulltext edition+" th" do
					fields(:edition)
				end
			end
		end
	end


	def post_refine_search(books)
		@posts = []
		@editions = [['--edition--',:all]] if params[:edition]=="all"
		@conditions = [['--condition--',:all]] if params[:condition]=="all"
		books.each do
	    	|book|
	    	if params[:edition]=="all" then
	    		@editions.append(book.edition) unless @editions.include? book.edition
	    	end
	    	Post.search do
	    		# Match Book id
	    		fulltext book.id do
	    			fields(:book_id)
	    		end

	    		# Match post_type (offer or request)
	    		if(params[:offer_request]!="both") then
	    			fulltext params[:offer_request] do
	    				fields(:post_type)
	    			end
	    		end

	    		# Match book condition
	    		if(params[:condition]!="all") then
	    			fulltext params[:condition] do
	    				fields(:condition)
	    			end
	    		end

	    		# Match book max/min price
	    		if(params[:low_price]!="") then
	    			with(:price).greater_than(params[:low_price].to_f-1)
	    		end
	    		if(params[:high_price]!="") then
	    			with(:price).less_than(params[:high_price].to_f+1)
	    		end
	    	end.results.each do
	      		|post|
	      		@posts.append(post)
	      		if params[:condition]=="all" then
		      		unless @conditions.include? post.condition then
		      			if post.condition!="Unacceptable"
		      				@conditions.append(post.condition)
		      			else
		      				@conditions.append(["Used - poor", post.condition])
		      			end
		      		end
		      	end
	    	end
	  	end

	  	@post_type = params[:offer_request]
	  	@search_for = params[:search_for]
	  	@search_field = params[:query]
	  	@condition = params[:condition]
	  	@edition = params[:edition]
	  	@msg = "Find "+@posts.length.to_s+" Posts"
	  	# @msg = params
	end
end
