<div class="notification-element-container">
	<div class="notification-element-box">
		<div class="notification-element-icon-box backgound-blue">
			<div class="notification-element-icon sk-icons sk-icons-{{=sk.type}}">&nbsp;</div>
		</div>
		<div class="notification-element-info-container">
			<div class="notification-element-info-box">
				<div class="notification-element-title">{{=sk.title}}</div>
				<div class="notification-element-time">{{=  timeAgo(sk.sendat) }}</div>
				<div class="clearfix"></div>
			</div>
			<div class="notification-element-buttons-box">
				<a href="#User/archiveNotification?id={{=sk.id}}" class="button confirm-box" module="NOTIFICATION_DELETE" mtitle="Delete notification" message="Are you sure you want to delete this notofication?">delete</a>
				{{? sk.read == false }}
				<a href="#User/notificationRead?id={{=sk.id}}" class="button" module="NOTIFICATION_MARK_READ">Mark as read</a> 
				{{?}}
				<a href="#User/notificationSearch?id={{=sk.id}}" class="button" module="NOTIFICATION_SHOW">Show</a> 
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>