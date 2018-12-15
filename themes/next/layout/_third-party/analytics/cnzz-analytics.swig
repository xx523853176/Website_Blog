{% if theme.cnzz_siteid %}

  <div style="display: none;">
    <script src="//s95.cnzz.com/z_stat.php?id={{ theme.cnzz_siteid }}&web_id={{ theme.cnzz_siteid }}" language="JavaScript"></script>
  </div>

  <script type="text/javascript">
    var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");
    document.write(unescape("%3Cspan id='cnzz_stat_icon_{{ theme.cnzz_siteid }}'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s5.cnzz.com/z_stat.php%3Fid%3D{{ theme.cnzz_siteid }}%26show%3Dpic' type='text/javascript'%3E%3C/script%3E"));
  </script>

{% endif %}
