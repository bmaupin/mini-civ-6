-- NOTE: Deleting all policies causes the government screen icon to never show,
--       because it only shows once the player has unlocked their first policy.
--       Alternatively, I tried deleting slots from all governments, but the
--       governments screen categorises governments into columns by number of
--       policy slots, so if they're all deleted then all governments get
--       stacked into one column and it's difficult to see their properties.
--       The workaround below is to delete all but a couple policies; if only
--       one policy is left, neither can be assigned for the first government
--       (which has exactly two policy slots).
DELETE FROM Types
  WHERE Kind = 'KIND_POLICY'
    AND Type != 'POLICY_URBAN_PLANNING'
    AND Type != 'POLICY_SURVEY';
