{% macro trimmer(column_name, node) %}
    upper(trim({{ column_name }}))
{% endmacro %}