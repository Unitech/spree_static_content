class Spree::StaticContentController < Spree::BaseController
  caches_action :show
  layout :determine_layout
  
  def show
    path = case params[:path]
    when Array
      '/' + params[:path].join("/")
    when String
      '/' + params[:path]
    when nil
      request.path
    end
    path = StaticPage::remove_spree_mount_point(path) unless Rails.application.routes.named_routes[:spree].path.spec.to_s == "/"
    path = path.gsub('//','/')
    unless @page = Spree::Page.visible.find_by_slug(path)
      render_404
    end
  end

  private
  
  def determine_layout
    return @page.layout if @page and @page.layout.present?
    'spree/layouts/spree_application'
  end

  def accurate_title
    @page ? (@page.meta_title ? @page.meta_title : @page.title) : nil
  end
end

