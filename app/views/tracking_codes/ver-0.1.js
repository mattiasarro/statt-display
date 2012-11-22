<script>
  var _statt = _statt || [];
  (function() {
    var script = document.createElement('script');
    script.type  = 'text/javascript';
    script.async = true;
    script.id    = 'statt-tracker';
    script.setAttribute('data-site-id', '<%= @site.id %>');
    // script.setAttribute('data-user_id', 'user-name');
    script.src = '<%= Rails.configuration.collect_host %>/track.js';
    var b = document.getElementsByTagName('script')[0];
    b.parentNode.insertBefore(script, b);
  })();
</script>