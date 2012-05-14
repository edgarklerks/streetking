<div id="info-car-box" title="Car info ([:0.manufacturer_name]&nbsp;&bull;&nbsp;[:0.name]&nbsp;&bull;&nbsp;[:0.year]&nbsp;&bull;&nbsp;level [:0.level])">
	<div class="info-car-box">
		<div class="info-car-image">&nbsp;
			<div id="info-car-part-info-box" class="info-car-part-info-box ui-corner-all">
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Top Speed <span>[:0.top_speed]</span> (km/h)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.top_speed/100)*100)]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Acceleration <span>[:0.acceleration]</span> (s)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.acceleration/100)*100)]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Braking <span>[:0.braking]</span></div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.braking/100)*100)]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Handling <span>[:0.handling]</span></div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.handling/100)*100)]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Weight <span>[:0.weight]</span> (kg)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.weight/100)*100)]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Improve <span>[:0.improvement]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((0.improvement/100)*100)]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="info-car-part-element-info-data-box info-car-part-element-info-float">
					<div class="info-car-part-element-info-data-name">Used <span>[:0.wear]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="width:[:0.wear]%"></div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<div id="info-car-info-box" class="info-car-info-box"></div>
		<div class="clearfix"></div>
	</div>
</div>