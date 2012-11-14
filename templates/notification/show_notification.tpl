<div mtitle="[:title]">
	<div><b>time:</b> [:eval TIMESTAMPTODATE(sendat)]</div>
	<div><b>message:</b> [:message]  </div>
	<div class="buttons-panel">
		<a href="#User/notification" class="button" module="RELOAD_NOTIFICATION">close</a>
		<a href="#User/archiveNotification?id=[:id]" class="button confirm-box" module="DELETE_NOTIFICATION" mtitle="Delete notification" message="Are you sure you want to delete this notofication?">delete</a>
	</div>
	<div class="clearfix"></div>
</div>