<div id="user-name-nick">[:nickname]<br><span>[:firstname] [:lastname] (level [:level])</span></div>
<div id="user-data-box">
	<div class="user-info-box">
		<div class="user-info-label">Money</div>
		<div class="user-info-data-box">
			<div class="user-info-icon sk-icon-white50 sk-icon-50-27-money"></div>
			<div class="user-info-data-container user-info-data-money"><span>[:money]</span></div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="user-info-box">
		<div class="user-info-label">Respect</div>
		<div class="user-info-data-box">
			<div class="user-info-icon sk-icon-white50 sk-icon-50-27-respect"></div>
			<div class="user-info-data-container">
				<div class="user-info-data"><span>[:respect]/???</span></div>
				<div class="user-info-data-progress-box ui-corner-all">
					<div class="user-info-data-progress ui-corner-all" style="width:[:eval 100-((50/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="user-info-box">
		<div class="user-info-label">Health</div>
		<div class="user-info-data-box">
			<div class="user-info-icon sk-icon-white50 sk-icon-50-27-health"></div>
			<div class="user-info-data-container">
				<div class="user-info-data"><span>[:energy]/[:max_energy]</span> <span id="refill_health"></span></div>
				<div class="user-info-data-progress-box ui-corner-all">
					<div class="user-info-data-progress ui-corner-all" style="width:[:eval ((energy/max_energy)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="user-info-box">
		<div class="user-info-label">Diamonds</div>
		<div class="user-info-data-box">
			<div class="user-info-icon sk-icon-white50 sk-icon-50-27-diamond"></div>
			<div class="user-info-data-container user-info-data-diamond"><span>[:diamonds]</span></div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>