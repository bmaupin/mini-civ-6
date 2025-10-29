# Religion

#### Disable religion

There is no existing game option to disable religion

```
$ egrep -i "faith|religion" steamassets/dlc/alexanderscenario/data/alexanderscenario_removedata.xml
                <Delete Type="CAPABILITY_FAITH"/>
                <Delete Type="CAPABILITY_RELIGION"/>
                <Delete Type="POLICY_WARS_OF_RELIGION"/>
                <Delete Type="QUEST_CONVERT_CAPITAL_TO_RELIGION"/>
                <Delete Type="SCORING_RELIGION"/>
                <Delete ID="Kurgan_Faith"/>
                <Delete ID="ColossalHead_FaithForest"/>
                <Delete ID="ColossalHead_FaithJungle"/>
                <Delete YieldChangeId="District_Faith"/>
                <Delete AgendaType="TRAIT_AGENDA_PREFER_FAITH"/>
                <Delete BuildingType="BUILDING_ORACLE" YieldType="YIELD_FAITH"/>
                <Delete ResourceType="RESOURCE_DYES" YieldType="YIELD_FAITH"/>
                <Row SectionId="RELIGIONS"/>
                <Delete CategoryType="CATEGORY_RELIGION"/>
                <Delete LineItemType="LINE_ITEM_RELIGION"/>
```