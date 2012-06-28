<div class="info-car-parts-info-element" alt="" title="">
	<a href="#Car/part?part_instance_id=[:part_instance_id]" class="info-car-part-button" alt="[:name]" title="[:name]">
		<div class="info-car-part-element-image-container ui-corner-all [:when (improvement > 0 & unique == false)]{info-car-part-element-image-container-improved}[:when (unique)]{info-car-part-element-image-container-unique}">
			<div class="info-car-part-element-image-box sk-icon-50x50-white-tr-75 sk-icons-50x50-[:name]"></div>
		</div>
	</a>
	<div class="clearfix"></div>
	<div class="car-element-info-part-element-box car-info-part-element-container [:when (improvement > 0 & unique == false)]{car-info-part-element-container-improved}[:when (unique)]{car-info-part-element-container-unique} ui-corner-all">
		<div class="car-info-part-element-image-container ui-corner-left car-info-part-element-image-container183 [:when (improvement > 0 & unique == false)]{car-info-part-element-image-container-improved}[:when (unique)]{car-info-part-element-image-container-unique}">
			<div class="car-info-part-element-image-box ui-corner-left sk-icons-100x100-white-tr-75 sk-icons-100x100-[:name]">&nbsp;</div>
		</div>
		<div class="car-info-part-element-info-container car-info-part-element-info-container183">
			<div class="car-info-part-element-info-box car-info-part-element-info-box120">
				<div class="car-info-part-element-info-about">
					<div>Manufacturer:&nbsp;<b>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</b></div>
					<div>Model:&nbsp;<b>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</b></div>
					<div>Type:&nbsp;<b>[:part_modifier]</b></div>
					<div>Level:&nbsp;<b>[:level]</b></div>
					<div>[:when (task_subject == true)] { <a href="#Part/tasks?id=[:part_instance_id]" class="button" module="GARAGE_PART_TASK_INFO">i</a> }</div>
				</div>
				<div class="car-info-part-element-info-data">
					<div class="car-info-part-element-info-data-box-container">
						<div class="car-info-part-element-info-data-box">
							<div class="car-info-part-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
							<div class="progress-bar-box-info ui-corner-all-2px">
								<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval (parameter1/100)*100]%"></div>
							</div>
						</div>
						[:when (parameter2_name)]{
							<div class="car-info-part-element-info-data-box">
								<div class="car-info-part-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
								<div class="progress-bar-box-info ui-corner-all-2px">
									<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval (parameter2/100)*100]%"></div>
								</div>
							</div>
						}
						<div class="car-info-part-element-info-data-box">
							<div class="car-info-part-element-info-data-name">Weight <span>+[:weight]</span> kg</div>
							<div class="progress-bar-box-info ui-corner-all-2px">
								<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((weight/100)*100)]%"></div>
							</div>
						</div>
						[:when (unique == false)]{
							<div class="car-info-part-element-info-data-box">
								<div class="car-info-part-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> %</div>
								<div class="progress-bar-box-info ui-corner-all-2px">
									<div class="progress-bar-info progress-bar-info-improve ui-corner-all-2px" style="width:[:eval ((improvement/100000)*100)]%"></div>
								</div>
							</div>
						}
						<div class="car-info-part-element-info-data-box">
							<div class="car-info-part-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
							<div class="progress-bar-box-info ui-corner-all-2px">
								<div class="progress-bar-info progress-bar-info-used185 ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="crearfix"></div>
		<a href="#" class="car-element-info-part-element-info-close ui-corner-all ui-dialog-titlebar-close ui-corner-all"><span class="ui-icon ui-icon-closethick">close</span></a>
	</div>
</div>