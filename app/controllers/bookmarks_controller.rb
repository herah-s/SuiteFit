class BookmarksController < ApplicationController
  # Inserted a authorization policy in front of each method as a reminder.
  # When writing the method, put it before saving to the database.
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  def index
    @bookmarks = policy_scope(Bookmark)
    if params[:result].present?
      @bookmarks = @bookmarks.where(result: params[:result])
    end
  end

  def show
    authorize @bookmark
    @message = Message.new
  end

  def create
    @apartment = Apartment.find(params[:apartment_id])
    @bookmark = Bookmark.new
    @bookmark.apartment = @apartment
    @bookmark.user = current_user
    authorize @bookmark
    if @bookmark.save
      redirect_to bookmarks_path(@bookmarks)
      # added a notice to notify the user that the bookmark saved
      flash[:notice] = "Bookmark saved!"
    else
      render "apartments/show", status: :unprocessable_entity
    end
  end

  def edit
    authorize @bookmark
    @items = current_user.items
  end

  def update
    authorize @bookmark
    arrangement_json = request.body.read
    @bookmark.update(arrangement: arrangement_json, result: params[:result])
  end

  def destroy
    authorize @bookmark
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
end
