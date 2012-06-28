<div class="small-element-container [:when (improvement > 0 & unique == false)]{small-element-container-improved}[:when (unique)]{small-element-container-unique} ui-corner-all">
	<div class="small-element-image-container small-element-image-container183 [:when (improvement > 0 & unique == false)]{small-element-image-container-improved}[:when (unique)]{small-element-image-container-unique} ui-corner-all">
		<div class="small-element-image-box sk-icons-100x180-white-tr-75 sk-icons-100x180-[:name] ui-corner-all">&nbsp;</div>
	</div>
	<div class="small-element-info-container small-element-info-container183">
		<div class="small-element-info-box small-element-info-box120">
			<div class="small-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</b></div>
				<div>Model:&nbsp;<b>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</b></div>
				<div>Type:&nbsp;<b>[:part_modifier]</b></div>
				<div>Level:&nbsp;<b>[:level]</b></div>
				<div>[:when (task_subject == true)] { <a href="#Part/tasks?id=[:part_instance_id]" class="button" module="GARAGE_PART_TASK_INFO">i</a> }</div>
			</div>
			<div class="small-element-info-data">
				<div class="small-element-info-data-box-container">
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (parameter1/100)*100]%"></div>
						</div>
					</div>
					[:when (parameter2_name)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Weight <span>+[:weight]</span> kg</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((weight/100)*100)]%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> %</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small progress-bar-small-improve ui-corner-all-2px" style="width:[:eval ((improvement/100000)*100)]%"></div>
							</div>
						</div>
					}
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small progress-bar-small-used ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>
						</div>
					</div>
					
				</div>
			</div>
		</div>
		<div class="small-element-button-box button-box-wider">
			<a href="#Market/sell?part_instance_id=[:part_instance_id]" class="button" module="GARAGE_PART_SELL">sell<div>&nbsp;</div></a>
			[:when (unique == false & floor(improvement/1000) < 100)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=improve_part" class="button cmd-improve" module="GARAGE_TASK">improve<div>&nbsp;</div></a>}
			[:when (wear > 0)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=repair_part" class="button cmd-repair" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
		</div>
	</div>
	<div class="crearfix"></div>
</div>