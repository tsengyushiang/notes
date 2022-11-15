# Command Line Tool

- `args.py`

   - basic

      ```
      from argparse import ArgumentParser, SUPPRESS

      def build_argparser():
         parser = ArgumentParser(add_help=False)
         args = parser.add_argument_group('Options')   
         args.add_argument('-h', '--help', action='help',default=SUPPRESS') 

         # custom command line input parameters       
         args.add_argument("-t", "--time", type=int,default=False)

         args.add_argument("--maskNoise", action='store_true', help='True only if defined in command line')

         return parser
      ```
      
   - custom command line

      - multiple float number 
         
         ` parser.add_argument('times', metavar='N', type=float, nargs='+',help='times for images')`

- `main.py`
   
   ```
   from args import build_argparser
   args = build_argparser().parse_args()
   print(args.time,args.maskNoise)
   ```

- usage

   - run `python main.py -t 123 --maskNoise`
   - will get `123 True` printed
   - [futher usages](https://docs.python.org/zh-tw/3/howto/argparse.html)

