class Brand
    class << self
        def rebrand?(app)
            app.config[:tech_docs][:show_govuk_logo] == true
        end
    end
end