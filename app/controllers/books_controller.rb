class BooksController < ApplicationController
	before_action :authenticate_user!
	before_action :ensure_correct_user,only: [:edit, :update, :destroy]

  def show
	@book_detail = Book.find(params[:id])
	@user = @book_detail.user
	@book = Book.new
  end

  def index
	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
	@book = Book.new
	@user = User.find(current_user.id)  
  end

  def create
    book = Book.new(book_params)
    book.user_id = current_user.id
    if book.save
      flash[:notice] = "You have creatad book successfully."
      redirect_to book_path(book)
    else
      @book = book
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  def edit
  	@book = Book.find(params[:id])
  end



  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      flash[:notice] = "You have creatad book successfully."
      redirect_to book_path(book)
    else
      @book = book
      render :edit
    end
  end

  def delete
  	@book = Book.find(params[:id])
  	@book.destoy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  def ensure_correct_user
    book = Book.find(params[:id])
    if book.user_id != current_user.id
      redirect_to books_path
    end
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

end
