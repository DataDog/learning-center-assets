It's best to build this package inside a lab, rather than to commit the dependencies into our source repo. Toward that end, these are the steps to follow while provisioning a lab. They could even be done in a custom image.

[Here are AWS's docs](https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-create-package-with-dependency) on packaging a Python app for Lambda.

1. Create a virtual environment
   ```
   python3 -m venv venv
   source venv/bin/activate
   ```

2. Install the required packages into the current directory
   ```
   pip install -r requirements.txt -t ./package
   ```

3. `cd package`

4. `zip -r ../discounts-lambda-package.zip .`

5. `cd ..`

6. `zip -g discounts-lambda-package.zip laambda_function.py`


