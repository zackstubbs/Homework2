---
title: "Class 2 HW - Student"
output: html_notebook
---
```{r}
set.seed(222)
```

# 1

Create a `parsnip` specification for a linear regression model.

# HW code
```{r}
#the goal of parsnip (from R help) is to provide a tidy, unified interface to models that can be used to try a range of models without getting bogged down in the syntactical minutiae of the underlying packages.
lm_spec <- linear_reg() %>%
  set_mode("regression") %>%
  set_engine("lm")
```

# 2

Once we have the specification we can `fit` it by supplying a formula expression and the data we want to fit the model on.
The formula is written on the form `y ~ x` where `y` is the name of the response and `x` is the name of the predictors.
The names used in the formula should match the names of the variables in the data set passed to `data`. 

Use `lm_spec` to fit the model of `medv` predicted by every predictor variable. Hint: you can use "." to specify every predictor.

# HW code

```{r}
lm_fit <- lm_spec %>%
  fit(medv ~ ., data=Boston)
lm_fit
#don't include "" around the . to specify every predictor. I received an error.
```

# 3

Get a summary of your model using `pluck` and `summary`

# HW code

```{r}
lm_fit %>% 
  pluck("fit") %>%
  summary()
```

# 4

Take a look at `lm_fit` with `tidy`

# HW Code

```{r}
#provides a a "tidier" view of the lm_fit outpout
tidy(lm_fit)
```

# 5

Extract the model statistics using `glance`

#HW code
```{r}
glance(lm_fit)
```

# 6

Get the predicted `medv` values from your model using `predict`

#HW code
```{r}
predict(lm_fit, new_data = Boston)
```


# 7

Bind the predicted columns to your existing data

#HW code

```{r}
bind_cols(
  predict(lm_fit, new_data = Boston),
  Boston
) %>%
  select(medv, .pred)
```

# 8

Now, make things easier by just using the `augment` function to do this.

#HW code
```{r}
augment(lm_fit, new_data = Boston)
```


# 9

Focus specifically on the median value and the `.pred`, then you can select those two columns

#HW code
```{r}
augment(lm_fit, new_data = Boston) %>%
  select(medv, .pred)
```


# 10

Create a `recipe` with an interaction step between lstat and age

#HW code
```{r}
#from r help, a recipe is a description of the steps to be applied to a data set in order to prepare it for data analysis. 
rec_spec <- recipe(medv ~ ., data = Boston) %>%
  step_interact(~ lstat:age)
```

# 11

Create a `workflow` and add your lm_spec model and your rec_spec recipe.

#HW code
```{r}
#workflow aggregates info. required to fit and predict from a model 
lm_wf <- workflow() %>%
  add_model(lm_spec) %>%
  add_recipe(rec_spec)
```

# 12

Fit your `workflow`.

#HW code
```{r}
lm_wf %>% fit(Boston)
```

