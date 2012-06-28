<div class="setup-part-element-info-data-box-container">
	<div class="setup-part-element-info-data-box-left">
		<div class="setup-part-element-info-data-box-left-container">
			<div><b>[:0.name]</b></div>
			<div>Type: <b>[:0.part_modifier]</b></div>
			<div>Level: <b>[:0.level]</b></div>
		</div>
	</div>
	<div class="setup-part-element-info-data-box-right">
		<div class="setup-part-element-info-data-box-right-container">
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">[:0.parameter1_name] <span>+[:0.parameter1]</span> [:when (0.parameter1_unit != null)]{([:0.parameter1_unit])}</div>
				<div class="progress-bar-box-small">
					<div class="progress-bar-small" style="left:-[:eval 100-((0.parameter1/100)*100)]%"></div>
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="setup-part-element-info-data-box setup-part-element-info-float">
				<div class="setup-part-element-info-data-name">Weight <span>+[:0.weight]</span> (kg)</div>
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
				<div class="setup-part-element-info-data-name">Improve <span>[:eval floor(0.improvement/1000)]</span> (%)</div>
				<div class="progress-bar-box-small">
					<div class="progress-improve-bar-small" style="left:-[:eval 100-((0.improvement/100000)*100)]%"></div>
				</div>
			</div>
		</div>
	}
	<div class="setup-part-element-info-data-box-right50">
		<div class="setup-part-element-info-data-box">
			<div class="setup-part-element-info-data-name">Used <span>[:eval floor(0.wear/1000)]</span> (%)</div>
			<div class="progress-bar-box-small">
				<div class="progress-wear-bar-small" style="width:[:eval floor(0.wear/1000)]%"></div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>
