[:when (requestParams.action == "Market/place")]{
	<ul class="additional-menu sk-icon-tui-50x50">
		[:when (requestParams.me == 0)]{
			<li class="sk-icon-50x50-marketplace ui-state-default ui-state-focus ui-tabs-selected ui-state-active">&nbsp;</li>
			<li class="sk-icon-50x50-marketplaceown"><a module="MARKETPLACE_USEDPARTS_ME" href="#Market/place?" alt="Own parts" title="Own parts">&nbsp;</a></li>
		}
		[:when (requestParams.me == 1)]{
			<li class="sk-icon-50x50-marketplace"><a module="MARKETPLACE_USEDPARTS" href="#Market/place?" alt="Marketplace parts" title="Marketplace parts">&nbsp;</a></li>
			<li class="sk-icon-50x50-marketplaceown ui-state-default ui-state-focus ui-tabs-selected ui-state-active">&nbsp;</li>
		}
		<li class="sk-icon-50x50-marketplacesearch "><a module="MARKETPLACE_SHOW_FILTER" href="#Market/place?" alt="Filter results" title="Filter results">&nbsp;</a></li>
	</ul>
}
<ul class="sk-icon-tui-50x50">
	[:when (requestParams.car_id > 0)]{<li class="sk-icon-50x50-body"><a module="MARKETPLACE_NEWCAR_TAB" href="#Market/model/?id=[:requestParams.car_id]" alt="Cars" title="Cars">&nbsp;</a></li>}
	[:when (requestParams.action == "Market/place")]{
		<li class="sk-icon-50x50-body">
			[:when (requestParams.me == 0)]{
				<a module="MARKETPLACE_USEDCARS_TABS" href="#Market/cars/?id=" alt="Cars" title="Cars">&nbsp;</a>
			}
			[:when (requestParams.me == 1)]{
				<a module="MARKETPLACE_USEDCARS_TABS" href="#Market/cars/?id=" alt="Cars" title="Cars">&nbsp;</a>
			}
		</li>
	}
	[:repeat data:nodes as:currtab] {
		<li class="sk-icon-50x50-[:currtab.content.Tab.0]"><a module="[:requestParams.module]" class="[:currtab.content.Tab.2]" href="#[:requestParams.action]/?part_type=[:currtab.content.Tab.0]&car_id=[:requestParams.car_id]" alt="[:currtab.content.Tab.0]" title="[:currtab.content.Tab.0]">&nbsp;</a></li>
	}
</ul>