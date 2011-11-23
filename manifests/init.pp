# Class: chiliproject
#
#   Starting point for installing chiliproject.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class chiliproject {
  include chiliproject::data
  anchor { 'begin': before => Anchor['end'] }
  anchor { 'end': }
}
