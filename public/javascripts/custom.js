$(function () {
	
	// CSS tweaks
	$('#header #nav li:last').addClass('nobg');
	$('.block_head ul').each(function() { $('li:first', this).addClass('nobg'); });
	$('.block table tr:odd').css('background-color', '#fbfbfb');
	$('.block form input[type=file]').addClass('file');
			
	
	// Web stats
	$('table.stats').each(function() {
		var statsType;
		
		if($(this).attr('rel')) { statsType = $(this).attr('rel'); }
		else { statsType = 'area'; }
		
		$(this).hide().visualize({		
			type: statsType,	// 'bar', 'area', 'pie', 'line'
			width: '880px',
			height: '240px',
			colors: ['#6fb9e8', '#ec8526', '#9dc453', '#ddd74c']
		});
	});
	
	
	// Messages
	$('.block .message').hide().append('<span class="close" title="Dismiss"></span>').fadeIn('slow');
	$('.block .message .close').hover(
		function() { $(this).addClass('hover'); },
		function() { $(this).removeClass('hover'); }
	);
		
	$('.block .message .close').click(function() {
		$(this).parent().fadeOut('slow', function() { $(this).remove(); });
	});
	
	
	// Form select styling
	$("form select.styled").select_skin();
	
	
	// Sidebar Tabs
	$(".sidebar_content").hide();
	$("ul.sidemenu li:first-child").addClass("active").show();
	$(".block").find(".sidebar_content:first").show();

	$("ul.sidemenu li").click(function() {
		$(this).parent().find('li').removeClass("active");
		$(this).addClass("active");
		$(this).parents('.block').find(".sidebar_content").hide();

		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});	
	
	
	// Block search
	$('.block .block_head form .text').bind('click', function() { $(this).attr('value', ''); });
	
	if(jQuery.browser.version.substr(0,1) < 7) {
		$('#header #nav li').hover(
			function() { $(this).addClass('iehover'); },
			function() { $(this).removeClass('iehover'); }
		);
	}
	
		
});
