# frozen_string_literal: true

module RedmineGttExport
  class MembersToCsv
    include Redmine::I18n

    def self.call(*_)
      new(*_).call
    end

    def initialize(project)
      @project = project
      @separator = l('general_csv_separator') == ',' ? ';' : ','
    end

    COLUMNS = %w(
      login firstname lastname mail project role
    )

    def call
      Redmine::Export::CSV.generate do |csv|
        csv << COLUMNS.map{|c| l "field_#{c}"}
        @project.members.each do |m|
          user = m.principal
          csv << [
            user.login, user.firstname, user.lastname, user.mail,
            @project.identifier,
            m.roles.map(&:name).join(@separator)
          ]
        end
      end
    end
  end
end