class <%= model_name.pluralize.camelcase %>Controller < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @<%= plural %> = <%= camel %>.all
  end

  def show
    <%= model_name %> = <%= camel %>.find(params[:id])
    if params[:row]
      render <%= model_name %>
    else
      render :partial => 'show', :locals => { :<%= model_name %> => <%= model_name %> }
    end
  end

  def new
    <%= model_name %> = <%= camel %>.new
    render :partial => 'new', :locals => { :<%= model_name %> => <%= model_name %> }
  end

  def create
    @<%= model_name %> = <%= camel %>.new(params[:<%= model_name %>])
    if @<%= model_name %>.save
      render :inline => "#{@<%= model_name %>.id}"
    else
      render :partial => 'errors', :status => 500
    end
  end

  def edit
    <%= model_name %> = <%= camel %>.find(params[:id])
    render :partial => 'edit', :locals => { :<%= model_name %> => <%= model_name %> }
  end

  def update
    @<%= model_name %> = <%= camel %>.find(params[:id])
    if @<%= model_name %>.update_attributes(params[:<%= model_name %>])
      render @<%= model_name %>
    else
      render :partial => 'errors', :status => 500
    end
  end

  def destroy
    <%= camel %>.find(params[:id]).destroy
    render :nothing => true
  end

  private

  def record_not_found
    flash[:error] = "Error, this <%= model_name %> doesn't exist"
    render :partial => 'errors', :status => 500 
  end

end