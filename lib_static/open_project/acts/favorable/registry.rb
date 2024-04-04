#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2024 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module OpenProject
  module Acts
    module Favorable
      module Registry
        def self.models
          @models ||= Set.new
        end

        def self.exists?(model)
          models.include?(model)
        end

        def self.instance(model_name)
          models.detect { |cls| cls.name == model_name.singularize.camelize }
        end

        def self.add(*models)
          models.each do |model|
            unless model.ancestors.include?(::OpenProject::Acts::Watchable)
              raise ArgumentError.new("Model #{model} does not include acts_as_watchable")
            end

            self.models << model
          end
        end
      end
    end
  end
end
