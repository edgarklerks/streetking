<div id="user-name-nick">{{=sk.nickname}}<br><span>{{=sk.firstname}} {{=sk.lastname}} (level {{=sk.level}})</span></div>
<div id="user-data-box">
	<div class="user-info-box-money">
		<div class="user-info-label">Money</div>
		<div class="user-info-data-box-money header-icons header-icons-money"><span class="user-info-data-box">{{=sk.money}}</span></div>
	</div>
	<div class="user-info-box-respect">
		<div class="user-info-label">Respect<span>{{=sk.respect}}/{{=sk.next_level.respect_need}} ({{=sk.next_level.respect_left}})</span></div>
		<div class="user-info-data-box-respect header-icons header-icons-respect">
			<div class="user-info-data-box">
				<div class="user-info-data-progress-box ui-corner-all-1px">
					<div class="user-info-data-progress ui-corner-all-1px" style="width:{{=sk.next_level.bar}}%"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="user-info-box-health">
		<div class="user-info-label">Health<span>{{=sk.energy}}/{{=sk.max_energy}} <samp id="refill_health"></samp></span></div>
		<div class="user-info-data-box-health header-icons header-icons-health">
			<div class="user-info-data-box">
			</div>
		</div>
	</div>
	<div class="user-info-box-diamond">
		<div class="user-info-label">Diamonds</div>
		<div class="user-info-data-box-diamond header-icons header-icons-diamond cursor-pointer" module="MARKETPLACE"><span class="user-info-data-box">{{=sk.diamonds}}</span></div>
	</div>
	<div class="clearfix"></div>
</div>
<div class="user-place">{{=sk.continent_name}}&nbsp;&middot;&nbsp;{{=sk.city_name}}</div>