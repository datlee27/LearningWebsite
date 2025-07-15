package Model;

public class Lecture {
    private int id, idCourse;
    private String title, videoUrl, status;

    public Lecture(int idCourse, String title, String videoUrl, String status) {
        this.idCourse = idCourse;
        this.title = title;
        this.videoUrl = videoUrl;
        this.status = status;
    }

    public Lecture(int id, int idCourse, String title, String videoUrl, String status) {
        this.id = id;
        this.idCourse = idCourse;
        this.title = title;
        this.videoUrl = videoUrl;
        this.status = status;
    }

    public Lecture() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdLecture() {
        return id;
    }

    public void setIdLecture(int idLecture) {
        this.id = idLecture;
    }

    public int getIdCourse() {
        return idCourse;
    }

    public void setIdCourse(int idCourse) {
        this.idCourse = idCourse;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Lecture{" +
               "idLecture=" + id +
               ", idCourse=" + idCourse +
               ", title=" + title +
               ", videoUrl=" + videoUrl +
               ", status=" + status +
               '}';
    }
}