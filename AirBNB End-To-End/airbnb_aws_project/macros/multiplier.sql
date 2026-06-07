{% macro multiplier(x, y, precision) %}
    round({{x}} * {{y}}, {{precision}})
{% endmacro %}