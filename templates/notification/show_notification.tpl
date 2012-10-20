<div mtitle="[:title]">
	<div><b>time:</b> [:eval TIMESTAMPTODATE(sendat)]</div>
	<div><b>message:</b> [:message]  </div>
	<div class="buttons-panel">
		<a href="#User/notification" class="button" module="RELOAD_NOTIFICATION">close</a>
<!--		<a href="#User/notification" class="button" module="SHOW_NOTIFICATIONS">close</a>-->
		<a href="#User/notificationDelete?id=[:id]" class="button" module="DELETE_NOTIFICATION">delete</a>
	</div>
	<div class="clearfix"></div>
</div>