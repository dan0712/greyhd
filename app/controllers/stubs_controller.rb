class StubsController < ActionController::Base
  layout :choose_layout
  LAYOUTS = ['admin', 'get_started', 'mailer', 'employee']

  def index
    @files = Dir.glob(Rails.root.join('app', 'views', 'stubs', '**/[^_]*.*'))
                .map { |file| %r{(stubs\/.*).html}.match(file)[1] }
                .select { |item| item != 'stubs/index' }
                .map { |file| file.split('/') }
                .group_by(&:second)

    render :index, layout: nil
  end

  def show
    respond_to do |format|
      format.html do
        if params_folder && Dir.exist?(folder_path)
          render "stubs/#{params_folder}/#{params_template}"
        else
          render params_template
        end
      end
    end
  end

  private

  def choose_layout
    layout = params_layout
    layout = params_folder if !layout && params_folder && !Dir.exist?(folder_path)
    layout || 'stubs'
  end

  def folder_path
    Rails.root.join('app', 'views', 'stubs', params_folder)
  end

  def params_folder
    params[:folder]
  end

  def params_layout
    LAYOUTS.detect do |layout|
      params_template.starts_with?(layout)
    end || params[:layout] || 'stubs'
  end

  def params_template
    params[:template]
  end
end
