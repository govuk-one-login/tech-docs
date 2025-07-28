class PathBuilder
    class << self
        def prefix(app)
            return '/' if app.development?
            return '/' unless app.config[:tech_docs][:use_service_link_for_favicon]

            link = app.config[:tech_docs][:service_link] || '/'
            link.end_with?('/') ? link : "#{link}/"
        end
    end
end