require 'fileutils'

class FilesController < ApplicationController
  def index
    unless Dir.exist?(@work_dir + "/files")
      path = Dir.pwd
      Dir.chdir(@work_dir)
      Dir.mkdir("files")
      Dir.chdir(path)
    end
    @content = get_content
    @draw = draw(@content, @work_dir + "/files")
    render "index"
  end

  def upload_file
    name = params[:upload].original_filename
    path = File.join(params[:path], name)
    File.open(path, "wb") { |f| f.write(params[:upload].read) }
    @content = get_content
    @draw = draw(@content, @work_dir + "/files")
    render "index"
  end

  def download_file
    send_file(params[:path], disposition: "attachment")
  end

  def create_dir
    name = params[:dir_name]
    path = Dir.pwd
    Dir.chdir(params[:path])
    Dir.mkdir(name)
    Dir.chdir(path)
    @content = get_content
    @draw = draw(@content, @work_dir + "/files")
    render "index"
  end

  def delete
    name = params[:name]
    path = Dir.pwd
    Dir.chdir(params[:path])
    if File.directory?(name)
      FileUtils.remove_dir(name, true)
    else
      FileUtils.remove_file(name, true)
    end
    Dir.chdir(path)
    @content = get_content
    @draw = draw(@content, @work_dir + "/files")
    render "index"
  end

  def draw(hash, path)
    html = ""
    hash.each do |key, value|
      id = rand(10000)
      html += "<div class='accordion-item'>"
      html += "<div class='mb-3 mt-2 collapsed' type='button' data-bs-toggle='collapse' data-bs-target='#collapse#{id}' aria-expanded='true' aria-controls='collapse#{id}'>"
      if File.file?(path+"/"+key)
        html += "<p class='bi bi-file-earmark-code-fill ms-3 m-0'><i class='ms-2'>#{key}</i>"
        html += "<a target=\"_blank\" href=\"/download_file?path=#{path+"/"+key}\" class=\"ms-3\"><button class=\"border-0\"><i class=\"bi bi-cloud-download-fill\"></i></button></a>"
        html += "<button name=\"button\" type=\"submit\" class=\"ms-3 border-0\" data-bs-toggle=\"modal\" data-bs-target=\"#delete_modal#{id}\"><i class=\"bi bi-trash3-fill\"></i></button>"
        html += "</p>"
        html += draw_modal_delete(id, path, key)
        html += "</div>"
      else
        html += "<p class='bi bi-folder-fill ms-3 m-0'><i class='ms-2'>#{key}</i>"
        html += "<button name=\"button\" type=\"submit\" class=\"ms-3 border-0\" data-bs-toggle=\"modal\" data-bs-target=\"#upload_modal#{id}\"><i class=\"bi bi-cloud-upload-fill\"></i></button>"
        html += "<button name=\"button\" type=\"submit\" class=\"ms-3 border-0\" data-bs-toggle=\"modal\" data-bs-target=\"#create_dir_modal#{id}\"><i class=\"bi bi-folder-plus\"></i></button>"
        html += "<button name=\"button\" type=\"submit\" class=\"ms-3 border-0\" data-bs-toggle=\"modal\" data-bs-target=\"#delete_modal#{id}\"><i class=\"bi bi-trash3-fill\"></i></button>"
        html += "</p>"
        html += draw_modal_upload(id, path+"/"+key)
        html += draw_modal_create_dir(id, path+"/"+key)
        html += draw_modal_delete(id, path, key)
        html += "</div>"
        html += "<div id='collapse#{id}' class='accordion-collapse collapse' aria-labelledby='heading#{id}'>"
        html += "<div class='accordion-body'>"
        html += draw(value, path+"/"+key)
        html += "</div>"
        html += "</div>"
      end
      html += "</div>"
    end
    return html.html_safe
  end

  private
  @path = []
  def get_content
    path = Dir.pwd
    Dir.chdir(@work_dir+"/files")
    tree = Dir.glob("**/*")
    Dir.chdir(path)
    hash = {}
    tree.each do |item|
      @path = item.split("/")
      insert_file(hash, 0)
    end
    return hash
  end

  def insert_file(hash, i)
    if hash.key?(@path[i])
      insert_file(hash[@path[i]], i+1)
    else
      hash[@path[i]] = {}
      return
    end
  end

  def draw_modal_upload(id, path)
    html = "<div class=\"modal fade\" id=\"upload_modal#{id}\" data-bs-backdrop=\"static\" tabindex=\"-1\" aria-labelledby=\"upload_modal_label#{id}\" aria-hidden=\"true\">
             <div class=\"modal-dialog\">
              <div class=\"modal-content\">
               <div class=\"modal-header\">
                <h5 class=\"modal-title\" id=\"upload_modal_label#{id}\">Загрузка файла</h5>
                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
               </div>
               <div class=\"modal-body\">
                  <form enctype=\"multipart/form-data\" action=\"/upload_file\" accept-charset=\"UTF-8\" method=\"post\">
                    <input type=\"hidden\" name=\"path\" value=\"#{path}\" autocomplete=\"off\">
                    <input type=\"file\" name=\"upload\" id=\"upload\" class=\"form-control\">
                    <hr>
                    <input type=\"submit\" name=\"commit\" value=\"Загрузить\" data-disable-with=\"Загрузить\" class=\"btn btn-primary\" onclick=\"document.getElementsByClassName('modal-backdrop')[0].remove();\">
                  </form>
               </div>
              </div>
            </div>
          </div>"
    return html
  end

  def draw_modal_create_dir(id, path)
    html = "<div class=\"modal fade\" id=\"create_dir_modal#{id}\" data-bs-backdrop=\"static\" tabindex=\"-1\" aria-labelledby=\"create_dir_modal_label#{id}\" aria-hidden=\"true\">
             <div class=\"modal-dialog\">
              <div class=\"modal-content\">
               <div class=\"modal-header\">
                <h5 class=\"modal-title\" id=\"create_dir_modal_label#{id}\">Создание каталога</h5>
                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
               </div>
               <div class=\"modal-body\">
                  <form enctype=\"multipart/form-data\" action=\"/create_dir\" accept-charset=\"UTF-8\" method=\"post\">
                    <input type=\"hidden\" name=\"path\" value=\"#{path}\" autocomplete=\"off\">
                    <div class=\"field form-group\">
                      <label for=\"dir_name\">Название каталога</label>
                      <input class=\"form-control\" type=\"text\" name=\"dir_name\" id=\"dir_name\">
                    </div>
                    <hr>
                    <input type=\"submit\" name=\"commit\" value=\"Создать\" data-disable-with=\"Создать\" class=\"btn btn-primary\" onclick=\"document.getElementsByClassName('modal-backdrop')[0].remove();\">
                  </form>
               </div>
              </div>
            </div>
          </div>"
    return html
  end

  def draw_modal_delete(id, path, name)
    html = "<div class=\"modal fade\" id=\"delete_modal#{id}\" data-bs-backdrop=\"static\" tabindex=\"-1\" aria-labelledby=\"delete_modal_label#{id}\" aria-hidden=\"true\">
             <div class=\"modal-dialog\">
              <div class=\"modal-content\">
               <div class=\"modal-header\">
                <h5 class=\"modal-title\" id=\"delete_modal_label#{id}\">Удаление каталога</h5>
                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>
               </div>
               <div class=\"modal-body\">
                  <form enctype=\"multipart/form-data\" action=\"/del_file_dir\" accept-charset=\"UTF-8\" method=\"post\">
                    <input type=\"hidden\" name=\"path\" value=\"#{path}\" autocomplete=\"off\">
                    <input type=\"hidden\" name=\"name\" value=\"#{name}\" autocomplete=\"off\">
                    <div class=\"field form-group\">"
    if File.directory?(File.join(path, name))
      html += "<p>Вы уверены, что хотите удалить каталог #{File.join(path, name)} со всем его содержимым?</p>"
    else
      html += "<p>Вы уверены, что хотите удалить файл #{File.join(path, name)}?</p>"
    end

    html +=        "</div>
                    <hr>
                    <input type=\"submit\" name=\"commit\" value=\"Удалить\" data-disable-with=\"Удалить\" class=\"btn btn-primary\" onclick=\"document.getElementsByClassName('modal-backdrop')[0].remove();\">
                  </form>
               </div>
              </div>
            </div>
          </div>"
    return html
  end
end
