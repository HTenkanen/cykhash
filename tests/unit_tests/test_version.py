import unittest

import cykhash


class VersionTester(unittest.TestCase): 

   def test_major(self):
      self.assertEqual(cykhash.__version__[0], 1)

   def test_minor(self):
      self.assertEqual(cykhash.__version__[1], 0)

   def test_last(self):
      self.assertEqual(cykhash.__version__[2], 2)
