<div mtitle="[:title]">
	<div><b>time:</b> {{=timeAgo(sk[0].sendat)}}</div>
	<div><b>message:</b> {{=sk[0].message}}  </div>
	<div class="buttons-panel">
		<a href="#User/notification" class="button" module="NOTIFICATION_CLOSE">close</a>
		<a href="#User/archiveNotification?id={{=sk[0].id}}" class="button confirm-box" module="NOTIFICATION_DELETE" mtitle="Delete notification" message="Are you sure you want to delete this notofication?">delete</a>
	</div>
	<div class="clearfix"></div>
</div>