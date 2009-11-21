function newSammyApp() {
	return new Sammy.Application(function() { with(this) {}});
}

function addCRUDRoutes(app, name, prefix, url_prefix) {
	
	if(prefix == null)
		prefix = '';
	if(url_prefix == null)
	  url_prefix = '';
	
  app.get('#/' + prefix + 'show/:id', function() { with(this) {
    partial('/' + url_prefix + name +'/' + params['id'], function(html) {
      $('#' + name + '_details').html(html);
      $('#' + name + '_edit').hide();
      $('#' + name + '_details').slideDown();
    });
  }});

  app.get('#/' + prefix + 'new', function() { with(this) {
    partial('/' + url_prefix + name + '/new', function(html) {
      $('#' + name + '_edit').html(html);
      $('#' + name + '_details').hide();
      $('#' + name + '_edit').slideDown();
    });
  }});

  app.post('#/' + prefix + 'create', function() { with(this) { 
    var data = $('#' + name + '_form').serialize();
    $.ajax({
      type: "POST",
      url: '/' + url_prefix + name,
      data: data,
      complete: function(xhr, statusText) {
        if(xhr.status == 200) {
          var id = xhr.responseText;
          partial('/' + url_prefix + name +'/' + id + '?row=true', function(html) {
            $('#' + name + '_list').append(html);
            $('#' + name + '_' + id).effect("highlight", {}, 3000);
          });
        }
        else
          showNotification(name, xhr.responseText);
      }
    });
  }});
 
  app.get('#/' + prefix + 'edit/:id', function() { with(this) {
    partial('/' + url_prefix + name + '/edit/' + params['id'], function(html) {
      $('#' + name + '_edit').html(html);
      $('#' + name + '_details').hide();
      $('#' + name + '_edit').slideDown();
    });
  }});
 
  app.post('#/' + prefix + 'update/:id', function() { with(this) {
    var id = params['id'];
    var data = $('#' + name + '_form').serialize();
    $.ajax({
      type: "POST",
      url: '/' + url_prefix + name + '/' + id,
      data: data,
      complete: function(xhr, statusText) {
        if(xhr.status == 200) {
					var row = '#' + name + '_' + id;
          $(row).after(xhr.responseText);
          $(row).remove();
          $(row).effect("highlight", {}, 3000);
        }
        else
					showNotification(name, xhr.responseText);
      }
    });
  }});
 
  app.get('#/' + prefix + 'delete/:id', function() { with(this) {
    var id = params['id'];
    $.ajax({
      type: "POST",
      data: "_method=delete",
      url: '/' + url_prefix + name + '/' + params['id'],
      complete: function(xhr, statusText) {
        if(xhr.status == 200)
          $('#' + name + '_' + id).remove();
        else
					showNotification(name, xhr.responseText);
      }
    });
 	}});
}

function showNotification(name, msg) {
	var div = $('#' + name + '_notif');
	div.html(msg);
	div.slideDown();

  window.setTimeout(function() {
   div.slideUp();
  }, 6000);
}