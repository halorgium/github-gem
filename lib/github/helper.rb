module GitHub
  class Helper
    def user_and_repo_from(url)
      case url
      when %r|^git://github\.com/(.*)$|: $1.split('/')
      when %r|^git@github\.com:(.*)$|: $1.split('/')
      end
    end

    def user_and_repo_for(remote)
      user_and_repo_from(url_for(remote))
    end

    def user_for(remote)
      user_and_repo_for(remote).first
    end

    def repo_for(remote)
      user_and_repo_for(remote).last
    end

    def project
      repo_for(:origin).chomp('.git')
    end

    def url_for(remote)
      `git config --get remote.#{remote}.url`.chomp
    end

    def remotes
      regexp = '^remote\.(.+)\.url$'
      `git config --get-regexp '#{regexp}'`.split(/\n/).map do |line|
        name_string, url = line.split(/ /, 2)
        m, name = *name_string.match(/#{regexp}/)
        [name, url]
      end
    end

    def tracking
      remotes.map do |(name, url)|
        if ur = user_and_repo_from(url)
          [name, ur.first]
        else
          [name, url]
        end
      end
    end

    def tracking?(user)
      tracking.include?(user)
    end

    def owner
      user_for(:origin)
    end

    def user_and_branch
      raw_branch = `git rev-parse --symbolic-full-name HEAD`.chomp.sub(/^refs\/heads\//, '')
      user, branch = raw_branch.split(/\//, 2)
      if branch
        [user, branch]
      else
        [owner, user]
      end
    end

    def branch_user
      user_and_branch.first
    end

    def branch_name
      user_and_branch.last
    end

    def public_url_for(user)
      "git://github.com/#{user}/#{project}.git"
    end

    def homepage_for(user, branch)
      "https://github.com/#{user}/#{project}/tree/#{branch}"
    end
  end
end
