module ::Overviews
  class OverviewsController < ::Grids::BaseInProjectController
    include OpTurbo::ComponentStream

    before_action :jump_to_project_menu_item
    before_action :set_sidebar_enabled

    menu_item :overview

    def project_custom_fields_sidebar
      render :project_custom_fields_sidebar, layout: false
    end

    def project_custom_field_section_dialog
      render(
        ProjectCustomFields::Sections::EditDialogComponent.new(
          project: @project,
          project_custom_field_section: find_project_custom_field_section
        ),
        layout: false
      )
    end

    def update_project_custom_values
      section = find_project_custom_field_section

      service_call = ::Projects::UpdateService
                      .new(
                        user: current_user,
                        model: @project
                      )
                      .call(
                        permitted_params.project.merge(
                          _limit_custom_fields_validation_to_section_id: section.id
                        )
                      )

      if service_call.success?
        update_sidebar_component
      else
        handle_errors(service_call.result, section)
      end

      respond_to_with_turbo_streams(status: service_call.success? ? :ok : :unprocessable_entity)
    end

    def jump_to_project_menu_item
      if params[:jump]
        # try to redirect to the requested menu item
        redirect_to_project_menu_item(@project, params[:jump]) && return
      end
    end

    private

    def find_project_custom_field_section
      ProjectCustomFieldSection.find(params[:section_id])
    end

    def set_sidebar_enabled
      @sidebar_enabled = @project.project_custom_fields.visible.any?
    end

    def handle_errors(project_with_errors, section)
      update_via_turbo_stream(
        component: ProjectCustomFields::Sections::EditDialogComponent.new(
          project: project_with_errors,
          project_custom_field_section: section
        )
      )
    end

    def update_sidebar_component
      update_via_turbo_stream(
        component: ProjectCustomFields::SidebarComponent.new(project: @project)
      )
    end
  end
end
