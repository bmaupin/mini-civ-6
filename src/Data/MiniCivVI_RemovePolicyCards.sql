-- NOTE: Deleting all policies causes the government button to never show,
--       because it only shows once the player has unlocked their first policy.
--       (see assets/ui/launchbar.lua).
--       Alternatively, deleting all slots from governments works but the
--       governments screen categorises governments into columns by number of
--       policy slots, so if they're all deleted then all governments get
--       stacked into one column and it's difficult to see their properties.
--       As a workaround, delete only all but one policy so that the government
--       button will show. But then set that policy as obsoleted by itself so
--       that the policy doesn't actually show on the government screen.
DELETE FROM Types
  WHERE Kind = 'KIND_POLICY'
    AND Type != 'POLICY_SURVEY';

INSERT OR REPLACE INTO ObsoletePolicies (PolicyType, ObsoletePolicy)
VALUES
  ('POLICY_SURVEY', 'POLICY_SURVEY');
