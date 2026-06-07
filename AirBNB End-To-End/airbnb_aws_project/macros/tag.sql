{% macro tag(column_name) %}
    CASE
        WHEN {{ column_name }} < 100 THEN 'Cheap'
        WHEN {{ column_name }} >= 100 AND {{ column_name }} <= 200 THEN 'Average'
        ELSE 'Expensive'
    END
{% endmacro %}