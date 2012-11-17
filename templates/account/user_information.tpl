<div id="user-name-nick">[:nickname]<br><span>[:firstname] [:lastname] (level [:level])</span></div>
<div id="user-data-box">
	<div class="user-info-box-money">
		<div class="user-info-label">Money</div>
		<div class="user-info-data-box-money header-icons header-icons-money"><span class="user-info-data-box">[:money]</span></div>
	</div>
	<div class="user-info-box-respect">
		<div class="user-info-label">Respect<span>[:respect]/???</span></div>
		<div class="user-info-data-box-respect header-icons header-icons-respect">
			<div class="user-info-data-box">
				<div class="user-info-data-progress-box ui-corner-all-1px">
					<div class="user-info-data-progress ui-corner-all-1px" style="width:[:eval 100-((50/100)*100)]%"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="user-info-box-health">
		<div class="user-info-label">Health<span>[:energy]/[:max_energy] <samp id="refill_health"></samp></span></div>
		<div class="user-info-data-box-health header-icons header-icons-health">
			<div class="user-info-data-box">
				<div class="user-info-data-progress-box ui-corner-all-1px">
					<div class="user-info-data-progress[:when (floor((energy/max_energy)*100) < 31)]{-low}[:when (floor((energy/max_energy)*100) > 30)]{-normal} ui-corner-all-1px" style="width:[:eval ((energy/max_energy)*100)]%"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="user-info-box-diamond">
		<div class="user-info-label">Diamonds</div>
		<div class="user-info-data-box-diamond header-icons header-icons-diamond cursor-pointer" module="MARKETPLACE"><span class="user-info-data-box">[:diamonds]</span></div>
	</div>
	<div class="clearfix"></div>
</div>
<div class="user-place">[:continent_name]&nbsp;&middot;&nbsp;[:city_name]</div>