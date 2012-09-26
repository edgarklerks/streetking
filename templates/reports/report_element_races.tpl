<div class="report-element-container backgound-darkgray">
	<div class="report-element-container-title">
		[:when (type == 0)]{Practise}
	</div>
	<div class="report-element-container-inner">
		<div class="report-element-image-container report-element-image-container-image" style='background-image:url([:when (part_type != null)]{ [:eval IMAGESERVER("[\"part\","+part_id+",\"" + part_type + "\"]")] } [:when (part_type == null)]{ [:eval IMAGESERVER("[\"track\","+data.track_data.track_id+",\"track\"]")] })'></div>
		<div class="report-element-data-container">
			<div class="report-element-info-container">
				<div class="report-element-infotext-container">
					<div class="race-money-opponent-element-car-image-container race-money-opponent-element-car-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+data.participant.rp_car.id+",\"car\"]")])'>&nbsp;</div>
				</div>
				<div class="report-element-vertical-line"></div>
				<div class="report-element-infobar-container">
					<div>Race time: <span>[:eval SECONDSTOTIME(data.race_time)]</span></div>
					<div>Respect: <span>[:data.rewards.respect]</span></div>
					<div>Money: <span>[:data.rewards.money]</span></div>
					<div><input type="button" value="more info" class="button" rid="[:data.race_id]"></div>
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="report-element-additional-info-box">
				<div>Time:&nbsp;<span>[:eval TIMESTAMPTODATE(time)]</span></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>