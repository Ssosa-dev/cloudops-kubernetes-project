from fastapi import FastAPI

app = FastAPI(title="My CloudOps Application")

@app.get("/")
def read_root():
    return {
        "status": "healthy",
        "message": "Hello World",
        "version": "1.1.0"
    }

@app.get("/healthz")
def healthz():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)