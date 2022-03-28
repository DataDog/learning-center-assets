# Distributed Tracing with APM Workshop on Kubernetes

This is a follow up repo to my [2018 Dash APM Workshop](https://github.com/burningion/dash-apm-workshop), incorporating feedback from the event.

Specifically, this adds:

* Starting with Automatic Instrumentation, and a more complex example program
* More live traffic, to see Trace Search (announced at DASH)
* Debugging a bigger, more complex system, to showcase a more real world use case
* More Datadog UI usage
* More relevant examples and names for traces
* More realistic errors 
* ... and should also work in Windows.
* ... and Kubernetes!

If you've stumbled upon it and have feedback, or have something you'd  like to see, feel free to create an issue.

# Before the Workshop / Prerequisites

The workshop is scheduled for an hour and a half. In this short time frame, having prerequisites installed is crucial to maximize everyone's hands on time.

Please ensure you accomplish at least steps 1 and 2 before the event, so everyone has a chance to complete the event.

1. Install [Docker CE](https://store.docker.com/search?type=edition&offering=community), allowing us to use Docker and Docker Compose. Please note you will be required to create an account in order to download Docker CE.

2. Install [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/). For now, it's best to just run it vanilla, as a VM. This way, we have isolation for our software.

3. Pull Docker images to your local machine *before the event*, so we don't all overwhelm the WiFi. 

You can do this by cloning this repo, and running a `docker-compose up` in the top level directory. This will pull the images and libraries to your local computer. This will take a few minutes. 

When it finishes, you'll be able to load http://localhost:5000, and see some example data. Refresh until you see 3 pumps listed. This means the downstream microservice containers have come up too.

3. (Optional) The workshop itself is written in a [Jupyter notebook](http://jupyter.org/), allowing you to mix and edit content locally. 

If you want to be able to add notes and save them locally, you'll want to install Jupyter, and then open the `Distributed Tracing Workshop.ipynb` by doing a `jupyter-notebook` in the top level repo directory.

This is completely optional, as Github has a built in viewer for Jupyter notebooks. You can view the repo's notebook [here](https://github.com/burningion/distributed-tracing-with-apm-workshop/blob/master/Distributed%20Tracing%20Workshop.ipynb).

# Running the Application in Kubernetes

![Water Sensor App](https://github.com/burningion/distributed-tracing-with-apm-workshop/raw/master/images/dashboard.png)

You'll need to have a Datadog account with APM and logging enabled. A free trial should work to play with.

The first thing we'll do is start minikube, link it to our host's Docker, and add the Datadog API key as a Kubernetes secret:

```bash
$ minikube start
$ eval $(minikube docker-env)
$ kubectl create secret generic datadog-api --from-literal=token=<YOUR_DATADOG_API_KEY>
$ kubectl create secret generic postgres-user --from-literal=token=postgres
$ kubectl create secret generic postgres-password --from-literal=token=<YOUR_PASSWORD>
```

Note, in order to see the running Docker containers from within your native Docker, you may need to either run it per shell instance, or add it to your `.bashrc`.

Next, let's open up our `datadog-agent.yaml` file, and see what settings we have in Kubernetes.

In order to grab the URL your application is running on with Minikube, you need to use a special command:

```bash
$ minikube service frontend-service --url
```

You can open the web app at `http://localhost:5000` (or your Minikube URL), create some pumps, and look at your Datadog traces to see the distributed traces.

The frontend of the app is a React node app using [Material UI](https://material-ui.com/). It lives in the `single-page-frontend` folder. You can start it up for development with a:

```bash
$ npm install
$ npm start
```

It should connect to the running frontend API container, allowing for easier development. When you're finished making changes, you can do a `npm build`, and then copy the javascript from the `build` subdirectory into the Flask frontend app.

# Ideas for Live Debugging via Tracing

These are some ideas, that have yet to be implemented:

* A bad deploy that triggers a problem, breaking parts of API
* Introducing latency in a service in the middle of the request lifecycle
* Introducing a traffic spike / poison payload downstream
* Introducing Chaos changes
