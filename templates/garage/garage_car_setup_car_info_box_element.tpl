<div class="setup-part-element-info-data-box-container">
	<div class="setup-part-element-info-data-box-left">
		<div class="setup-part-element-info-data-box-left-container">
			<div>Manufacturer: <b>[:0.manufacturer_name]</b></div>
			<div>Model: <b>[:0.name]</b></div>
			<div>Year: <b>[:0.year]</b></div>
			<div>Level: <b>[:0.level]</b></div>
		</div>
	</div>
	<div class="setup-part-element-info-data-box-right">
		<div class="setup-part-element-info-data-box-right-container">
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">Top Speed <span>[:0.top_speed]</span> (km/h)</div>
				<div class="progress-bar-box-small">
					<div class="progress-bar-small" style="left:-[:eval 100-((0.top_speed/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">Acceleration <span>[:0.acceleration]</span> (s)</div>
				<div class="progress-bar-box-small">
					<div class="progress-bar-small" style="left:-[:eval 100-((0.acceleration/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">Braking <span>[:0.braking]</span></div>
				<div class="progress-bar-box-small">
					<div class="progress-bar-small" style="left:-[:eval 100-((0.braking/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">Handling <span>[:0.handling]</span></div>
				<div class="progress-bar-box-small">
					<div class="progress-bar-small" style="left:-[:eval 100-((0.handling/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">Weight <span>[:0.weight]</span> (kg)</div>
				<div class="progress-bar-box-small">
					<div class="progress-bar-small" style="left:-[:eval 100-((0.weight/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
	<hr>
	[:when (0.unique == false)]{
		<div class="setup-part-element-info-data-box-left50">
			<div class="setup-part-element-info-data-box">
				<div class="setup-part-element-info-data-name">Improve <span>[:0.improvement]</span> (%)</div>
				<div class="progress-bar-box-small">
					<div class="progress-improve-bar-small" style="left:-[:eval 100-((0.improvement/100)*100)]%"></div>
				</div>
			</div>
		</div>
	}
	<div class="setup-part-element-info-data-box-right50">
		<div class="setup-part-element-info-data-box">
			<div class="setup-part-element-info-data-name">Used <span>[:0.wear]</span> (%)</div>
			<div class="progress-bar-box-small">
				<div class="progress-wear-bar-small" style="width:[:0.wear]%"></div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>
