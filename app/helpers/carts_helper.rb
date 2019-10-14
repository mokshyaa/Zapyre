module CartsHelper
	def buy
	  @carts.each do |cart|
	    if cart.user_id == current_user.id
	   	 	cart.user_id
  			cart.quantity
		    form_with(model:  @order,  url: orders_path, method: "post", local: true) do |form| 
			  	form.hidden_field :quantity, value: cart.quantity 
				  form.submit 'Buy'
			  end
		  end
	  end
  end
end
