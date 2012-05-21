<ul class="sk-icon-tui-50x50">
	[:when (requestParams.car_id > 0)]{<li class="sk-icon-50x50-body"><a module="MARKETPLACE_NEWCAR_TAB" href="#Market/model/?id=[:requestParams.car_id]" alt="Cars" title="Cars">&nbsp;</a></li>}
	[:when (requestParams.action == "Market/place")]{
		<li class="sk-icon-50x50-body">
			
			[:when (requestParams.me == 0)]{
				<a module="MARKETPLACE_USEDCARS_INNER_TABS" href="#Market/cars/?id=" alt="Cars" title="Cars">&nbsp;</a>
			}
			[:when (requestParams.me == 1)]{
				<a module="MARKETPLACE_USEDCARS_ME_INNER_TABS" href="#Market/cars/?id=" alt="Cars" title="Cars">&nbsp;</a>
			}
		</li>
	}
	[:repeat data:nodes as:currtab] {
		<li class="sk-icon-50x50-[:currtab.content.Tab.0]"><a module="[:requestParams.module]" class="[:currtab.content.Tab.2]" href="#[:requestParams.action]/?part_type=[:currtab.content.Tab.0]&car_id=[:requestParams.car_id]" alt="[:currtab.content.Tab.0]" title="[:currtab.content.Tab.0]">&nbsp;</a></li>
	}
</ul>