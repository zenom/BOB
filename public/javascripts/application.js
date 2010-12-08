var dashboard = $.sammy('#builds', function() {
  this.use(Sammy.Haml);
  var context = this;
  var timerInt;

  this.bind('load-builds', function(evt, data) {
    context = this;
    url = (typeof(data) == 'object') ? '/list.json' : '/list/' + data + '.json'
    $.getJSON(url, function(builds) {
      $.each(builds, function(i, build) {
        project_page = (typeof(data) == 'object') ? false : true;
        found = context.$element().find('#' + build.id).length;
        context.render('javascripts/templates/build.js.haml', {build: build, project_page: project_page}, function(tmpl) {
          if(found) {
            $('#' + build.id).replaceWith(tmpl);
          } else {
            context.$element().append($(tmpl).hide().fadeIn('slow'));
          }
        });

      })
    });
    //context.trigger('update-timer', url);
  });

  this.bind('update-timer', function(evt, data) {
    clearInterval(timerInt);
    timerInt = setInterval(function() {
      (data == undefined) ? context.trigger('load-builds') : context.trigger('load-builds', data); 
    }, 5000);
  });

  this.get('#/dashboard', function(context) {
    context.$element().html('');
    context.trigger('load-builds');
    context.trigger('update-timer');
  });

  this.get('#/dashboard/:project', function(context) {
    context.$element().html('');
    context.trigger('load-builds', this.params['project']);
    context.trigger('update-timer', this.params['project']);
  });

});

$(function() {

  /* auto build command */
  $('.command').live('keyup', function() {
    command     = $(this).val().split(/\r\n|\r|\n/);
    parent_div  = $(this).parent().parent();
    pre_area    = parent_div.find('.pre:first');
    pre_area.html(command.join(' && '));
  });

  /* hide messages on a timer */
  $('div.message').fadeIn('fast').delay(5000).fadeOut('slow');

  /* project / step management */
  $('.show_step').click(function() {
    parent = $(this).parent().parent().parent();
    parent.find('.step-form:first').toggle();
  });

  $('.addstep').click(function() {
    step = $('.step:first').clone();
    cmd_cnt = $('.step').length;
    step.find('h2').html('New Command');
    step.find('.pre').html('');
    
    step.find(':input').each(function() {
      field = $(this);
      if(field.hasClass('command')) {
        // our textarea
        field.prev().attr('for', 'project_steps_attributes_' + cmd_cnt + '_command');
        field.attr('name', 'project[steps_attributes][' + cmd_cnt + '][command]');
        field.attr('id', 'project_steps_attributes_' + cmd_cnt + '_command');
      } else {
        // input fields
        field.prev().attr('for', 'project_steps_attributes_' + cmd_cnt + '_name');
        field.attr('name', 'project[steps_attributes][' + cmd_cnt + '][name]');
        field.attr('id', 'project_steps_attributes_' + cmd_cnt + '_name');
      }
      field.val('');
    })
    $('.step:last').after(step);
  });
  

  $('a.delete_step').live('click', function(e) {
    e.preventDefault();
    do_delete = confirm("Are you sure you want to delete this step?");
    if(do_delete) {
      url = $(this).attr('href');
      $(this).parent().slideUp('slow', function() {
        $(this).remove();
      });
      $.get(url);
    }
  });


});
