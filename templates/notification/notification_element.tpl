<div class="notification-element-container">
	<div class="notification-element-box">
		<div class="notification-element-icon-box backgound-blue">
			<div class="notification-element-icon sk-icons sk-icons-[:type]">&nbsp;</div>
		</div>
		<div class="notification-element-info-container">
			<div class="notification-element-info-box">
				<div class="notification-element-title">[:title]</div>
				<div class="notification-element-time">[:timeAgo]</div>
				<div class="clearfix"></div>
			</div>
			<div class="notification-element-buttons-box">
				<a href="#User/notificationSearch?id=[:id]" class="button" module="SHOW_NOTIFICATION">Show</a> 
				[:when (read == false)] {<a href="#User/notificationRead?id=[:id]" class="button" module="READ_NOTIFICATION">Mark as read</a> }
				<a href="#User/archiveNotification?id=[:id]" class="button confirm-box" module="DELETE_NOTIFICATION" mtitle="Delete notification" message="Are you sure you want to delete this notofication?">delete</a>

			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>