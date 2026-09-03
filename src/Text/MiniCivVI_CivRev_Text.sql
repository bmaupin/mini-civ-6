-- Take the first sentence of the barracks description and the first sentence of the
-- stable description and use that as the text for the barracks, with two newlines in
-- between, for all languages.
UPDATE LocalizedText
SET Text =
  substr(
    Text,
    1,
    instr(Text, '.')
  ) || '[NEWLINE][NEWLINE]' || (
    SELECT substr(
      stable.Text,
      1,
      instr(stable.Text, '.')
    )
    FROM LocalizedText AS stable
    WHERE stable.Tag = 'LOC_BUILDING_STABLE_DESCRIPTION'
      AND stable.Language = Language
  )
WHERE Tag = 'LOC_BUILDING_BARRACKS_DESCRIPTION';

INSERT INTO LocalizedText (Language, Tag, Text)
VALUES (
  'en_US',
  'LOC_WORLD_RANKINGS_VICTORY_CIVREV_ECONOMIC',
  'Gold: {1_GoldInTreasury}/{2_GoldForVictory}'
  -- '{1_CompletedCivics}/{2_TotalCivics} Civics, {3_CompletedTechs}/{4_TotalTechs} Technologies'
),
(
  'en_US',
  'LOC_VICTORY_CIVREV_ECONOMIC_NAME',
  'Economic Victory'
),
(
  'en_US',
  'LOC_VICTORY_CIVREV_ECONOMIC_DESCRIPTION',
  'TODO: Should contain full stylised description that shows in world rankings dialogue'
),
(
  'en_US',
  'LOC_VICTORY_CIVREV_ECONOMIC_TAB_NAME',
  'Economic'
);
